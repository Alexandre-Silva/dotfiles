#[macro_use]
extern crate lazy_static;
extern crate time;
extern crate regex;

use std::ops::Deref;
use std::borrow::Cow;
use std::borrow::Borrow;
use std::collections::HashMap;
use std::io;
use std::path::{Path, PathBuf};
use std::fs::{File, DirBuilder};
use regex::Regex;
use time::Tm;

lazy_static! {
static ref BCK_RE: Regex = Regex::new(r"~([0-9]{8}-[0-9]{6})").unwrap();
}

static BCK_TS: &'static str = "%Y%m%d-%H%M%S";

#[derive(Debug)]
struct Conf {
    local: PathBuf,
    bkp: PathBuf,
}

fn load_conf() -> Conf {
    Conf {
        local: PathBuf::from("/tmp/synconver/local"),
        bkp: PathBuf::from("/tmp/alex/.stversions"),
    }
}


fn find<F>(file: &Path, cb: &mut F) -> io::Result<()>
    where F: FnMut(&Path)
{
    if file.is_dir() {
        for entry in file.read_dir()? {
            let f = entry?.path();
            find(f.as_path(), cb)?;
        }
    } else if file.is_file() {
        cb(file);
    }

    Ok(())
}

fn test_setup(conf: &Conf) -> io::Result<()> {
    DirBuilder::new().recursive(true)
        .create(&conf.local)?;

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

type FilesHM<'a> = HashMap<&'a str, SyncFile>;

fn main() {
    let c = load_conf();

    println!("");
    if let Some(e) = test_setup(&c).err() {
        println!("{}", e);
        return;
    }

    println!("{}",
             BCK_RE.replace("/tmp/alex/.stversions/gtd/mcast~20160509-091951.org", ""));


    let files: FilesHM = HashMap::new();

    let _ = find(c.bkp.as_path(),
                 &mut |pb: &Path| {

        let pb_str = pb.to_str().unwrap();
        if let Some(cap) = BCK_RE.captures(pb_str) {
            if let Some(t) = time::strptime(&cap[1], BCK_TS).ok() {

                let k = BCK_RE.replace(pb_str, "");
                let mut e = files.entry(k.deref()).or_insert(SyncFile::new({
                    let pb = PathBuf::new();
                    pb.push(k.borrow());
                    pb
                }));
                // files_bkp.push(SyncFile::new(PathBuf::from(pb_str), t));
                // files.entry()
            }
        }
    });

}
