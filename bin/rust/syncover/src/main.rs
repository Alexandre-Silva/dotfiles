#[macro_use]
extern crate lazy_static;
extern crate time;
extern crate regex;
extern crate getopts;

use getopts::Options;
use regex::Regex;
use std::collections::HashMap;
use std::env;
use std::fs::{File, DirBuilder};
use std::fs;
use std::io::{self, BufRead};
use std::ops::{Deref, Index};
use std::path::{Path, PathBuf};
use std::string::String;
use time::Tm;

lazy_static! {
static ref BCK_RE: Regex = Regex::new(r"~([0-9]{8}-[0-9]{6})").unwrap();
}

static BCK_TS: &'static str = "%Y%m%d-%H%M%S";

#[derive(Debug)]
struct Conf {
    local: PathBuf,
    bkp: PathBuf,
    only_deleted: bool,
}

impl Conf {
    fn default() -> Conf {
        Conf {
            local: PathBuf::from("/home/alex/dir-syncers/syncthing/"),
            bkp: PathBuf::from("/home/alex/dir-syncers/syncthing/.stversions"),
            only_deleted: false,
        }
    }
}

fn find<F>(file: &Path, cb: &mut F) -> io::Result<()>
    where F: FnMut(&Path)
{
    if file.is_dir() {
        for entry in file.read_dir()? {
            let f = entry?.path();
            if let Some(fname) = f.file_name() {
                if fname != ".stversions" {
                    find(f.as_path(), cb)?;
                }
            }

        }
    } else if file.is_file() {
        cb(file);
    }

    Ok(())
}

fn test_setup(conf: &Conf) -> io::Result<()> {
    DirBuilder::new().recursive(true).create(&conf.local)?;

    File::create(conf.local.join("a.txt"))?;
    File::create(conf.local.join("b.txt"))?;
    File::create(conf.local.join("c.txt"))?;

    Ok(())
}

#[derive(Debug)]
struct SyncFile {
    path: PathBuf,
    bcks: Vec<SyncFileBck>,
}

impl SyncFile {
    fn new(pb: PathBuf) -> SyncFile {
        SyncFile {
            path: pb,
            bcks: Vec::new(),
        }
    }

    fn push_bkp(&mut self, bkp: SyncFileBck) {
        self.bcks.push(bkp)
    }
}

#[derive(Debug)]
struct SyncFileBck {
    path: PathBuf,
    tm: Tm,
}

impl SyncFileBck {
    fn new(pb: PathBuf, tm: Tm) -> SyncFileBck {
        SyncFileBck { path: pb, tm: tm }
    }
}

type FilesHM = HashMap<String, SyncFile>;


fn build_opts() -> Options {
    let mut opts = Options::new();

    opts.optflag("d", "deleted", "only show deleted files");
    opts.optflag("h", "help", "print this help menu");

    return opts;
}

fn parse_options(args: &Vec<String>, conf: &mut Conf) {
    let opts = build_opts();

    let matches = match opts.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => panic!(f.to_string()),
    };

    conf.only_deleted = matches.opt_present("d");
}

fn scan_files(bkp: &Path) -> FilesHM {
    let mut files: FilesHM = HashMap::new();

    let bkp_len = bkp.to_str().unwrap().len();

    let _ = find(bkp,
                 &mut |pb: &Path| {

        let (_, pb_str) = pb.to_str().unwrap().split_at(bkp_len + 1);

        if let Some(cap) = BCK_RE.captures(pb_str) {
            if let Some(t) = time::strptime(&cap[1], BCK_TS).ok() {

                let k = BCK_RE.replace(pb_str, "");

                let sfb = SyncFileBck::new(PathBuf::from(pb_str.clone()), t);

                if files.contains_key(k.deref()) {
                    files.get_mut(k.deref()).unwrap().push_bkp(sfb);
                } else {
                    let mut sf = SyncFile::new(PathBuf::from(String::from(k)));
                    sf.push_bkp(sfb);
                    files.insert(String::from(sf.path.to_str().unwrap()), sf);
                }
            }
        }
    });

    // sorts each file.bcks from oldest to newest backup
    for v in files.values_mut() {
        v.bcks.sort_by(|a, b| a.tm.cmp(&b.tm));
    }

    return files;
}


type FilesView<'a> = Vec<&'a String>;
fn files_view<'a>(files: &'a FilesHM, conf: &Conf) -> FilesView<'a> {
    let mut files2show: Vec<&String> = files.iter()
        .map(|kv| kv.0)
        .filter(|k| {
                    let exists = conf.local.join(Path::new(k)).exists();
                    !(conf.only_deleted && exists)
                })
        .collect();

    files2show.sort();

    return files2show;
}

fn files_view_print(filesv: &FilesView) {
    for (i, file_path) in filesv.iter().enumerate() {
        println!("{:3} {}", i, file_path);
    }
}

fn files_select_controler(filesv: &FilesView) -> Vec<usize> {
    println!("Select a file to recover:");

    let mut line = String::new();
    let _ = io::stdin().read_line(&mut line).expect("Could not read line");
    let line = String::from(line.trim());
    let selected_file: usize = line.parse().unwrap();

    let mut files2recover: Vec<usize> = Vec::new();
    files2recover.push(selected_file);

    return files2recover;
}


fn recover(files: &FilesHM, filesv: FilesView, to_recover: Vec<usize>, conf: &Conf) {
    for index in &to_recover {
        let sync_file: &SyncFile = files.get(filesv[*index]).unwrap();

        let from = conf.bkp.join(sync_file.bcks[sync_file.bcks.len() - 1].path.clone());
        let to = conf.local.join(sync_file.path.clone());

        let result = match fs::copy(&from, &to) {
            Ok(_) => "succeeded",
            Err(_) => "failed",
        };

        println!("Copy {}\n |   {}\n `-> {}",
                 result,
                 from.to_str().unwrap(),
                 to.to_str().unwrap());

    }
}

fn main() {
    let mut c = Conf::default();

    let args: Vec<String> = env::args().collect();
    let program = args[0].clone();
    parse_options(&args, &mut c);

    let files = scan_files(&c.bkp);
    let filesv = files_view(&files, &c);

    files_view_print(&filesv);
    let files2recover = files_select_controler(&filesv);
    recover(&files, filesv, files2recover, &c);

    // recover(&files2show, files2recover);
}
