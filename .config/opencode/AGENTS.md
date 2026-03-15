# Agents

## General guidelines

1. Do not remove comments on editing files. If there is a comment it should stay there.

## Rust

- Use `cargo fmt` to format your code
- Use `cargo clippy` to check for common mistakes

### Dependencies

- always use `cargo add` to add new crates to Cargo.toml instead of doing it manually

### Imports

- mash imports together and let rustfmt order them automatically
- add workspace dependencies like this futures.workspace = true if they do not require special features
- add all constants right after imports before the other code

### Logging

- Use `tracing` crate for logging
- Use `tracing-subscriber` crate for logging
- always initialize tracing logger at the start of main function
- use structured logging to string templates: tracing::info!(name=%name, "Hello") instead of tracing::info!("Hello {}", name)

