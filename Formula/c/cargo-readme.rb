class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/livioribeiro/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "0044a2b199aa3ef8ed473bbec7af32a5a00579f755414e0c55707617fc2951b0"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cargo-readme --version")

    (testpath/"Cargo.toml").write <<~TOML
      [package]
      name = "test"
      version = "0.1.0"
      edition = "2018"
    TOML

    (testpath/"src/lib.rs").write <<~RUST
      //! # Example
      //!
      //! ```
      //! assert_eq!(2 + 2, 4);
      //! ```
    RUST

    system bin/"cargo-readme", "readme", "--output", testpath/"README.md"
    assert_match "# test", (testpath/"README.md").read
  end
end
