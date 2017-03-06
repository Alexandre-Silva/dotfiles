#[macro_use]
extern crate lazy_static;
extern crate time;
extern crate regex;

use std::io;
use std::convert::AsRef;
use std::path::{Path, PathBuf};
use std::fs::{File, DirBuilder};
use std::ops::Fn;
use regex::Regex;
use time::Tm;

lazy_static! {
static ref BCK_RE: Regex = Regex::new(r"^.*~([0-9]{8}-[0-9]{6}).*$").unwrap();
}

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
    bkp: PathBuf,
    tm: Tm,
}

impl SyncFile {
    fn new(pb: PathBuf, tm: Tm) -> SyncFile {
        SyncFile { bkp: pb, tm: tm }
    }
}

fn main() {
    let c = load_conf();

    println!("");
    if let Some(e) = test_setup(&c).err() {
        println!("{}", e);
        return;
    }

    let mut files_bkp = Vec::new();

    let _ = find(c.bkp.as_path(),
                 &mut |pb: &Path| {
        let pb_str = pb.to_str().unwrap();
        if let Some(cap) = BCK_RE.captures(pb_str) {
            if let Some(t) = time::strptime(&cap[1], "%Y%m%d-%H%M%S").ok() {
                files_bkp.push(SyncFile::new(PathBuf::from(pb_str), t));
            }
        }
    });

}
