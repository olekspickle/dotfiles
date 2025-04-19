use std::{fs, process};

const HOOKS: &[&str] = &["pre-commit"];

fn main() {
    HOOKS.iter().for_each(|h| {
        let (mut cmd, exists) = install_hook(h);
        if !exists {
            println!("cargo:warning=Copy pre-commit hook");
            cmd.spawn().expect("Failed to copy the commit hook");
        }
    });
}

fn install_hook(hook_name: &str) -> (process::Command, bool) {
    let crate_root = env!("CARGO_MANIFEST_DIR");

    #[cfg(unix)]
    let (cmd, exists) = {
        let input = format!("{crate_root}/.git_hooks/{hook_name}");
        let output = format!("{crate_root}/.git/hooks/{hook_name}");
        let mut cmd = process::Command::new("cp");
        cmd.args([&input, &output]);

        (cmd, fs::metadata(&output).is_ok())
    };

    // Note: Not tested on windows (!!!)
    #[cfg(windows)]
    let (cmd, exists) = {
        let input = format!("{crate_root}\\.git_hooks\\{hook_name}");
        let output = format!("{crate_root}\\.git\\hooks\\{hook_name}");
        let mut cmd = process::Command::new("cmd");
        cmd.args(["/C", "xcopy", &input, &output, "/Y"]);
        (cmd, fs::metadata(&output).is_ok())
    };

    (cmd, exists)
}
