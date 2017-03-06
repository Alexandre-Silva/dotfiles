#[macro_use]
extern crate lazy_static;
extern crate regex;

use std::io;
use std::convert::AsRef;
use std::path::{Path, PathBuf};
use std::fs::{File, DirBuilder};
use std::ops::Fn;
use regex::Regex;

lazy_static! {
static ref BCK_RE: Regex = Regex::new(r"^.*~[0-9]{8}-[0-9]{6}.*$").unwrap();
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


fn find<F>(file: &Path, cb: &F) -> io::Result<()>
    where F: Fn(&Path)
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

fn main() {
    let c = load_conf();

    println!("");
    if let Some(e) = test_setup(&c).err() {
        println!("{}", e);
        return;
    }

    let _ = find(c.bkp.as_path(),
                 &|pb: &Path| {
                     let pb_str = pb.to_str().unwrap();
                     println!("{} {}", BCK_RE.is_match(pb_str), pb_str);
                 });
}
