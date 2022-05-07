fn main() {
    cc::Build::new()
        .file("src/runtime.c")
        .compile("runtime");
}