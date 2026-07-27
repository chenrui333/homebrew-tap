class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/webern/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "632cf4279e39657130094def56462e5eda38eb521eabbde92553ce76e9147f2b"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "443d2a7ff42bccd4afb30f78cce7d8a1793d0d86c0efe811d59101b7da8fd904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc45cf809821fabd9cacdea0a4010914ffb0ddf2cd0af8b337e238d65d79bc67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80dce9b75d2d286862501f82658c0b040995b593317af4d4f30c4ef42e6bda45"
    sha256 cellar: :any,                 arm64_linux:   "6525eb4ce2a0992cb0019995fb7d29f606c52888a8df00e049183a22b05b9fd1"
    sha256 cellar: :any,                 x86_64_linux:  "0615a4dad9852fb18b39f17ebd4e9f6cab962526836d019b909f7274bd53e0fc"
  end

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
