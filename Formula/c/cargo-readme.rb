class CargoReadme < Formula
  desc "Generate README.md from docstrings"
  homepage "https://github.com/webern/cargo-readme"
  url "https://github.com/webern/cargo-readme/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "3fbede8b19d108c97a8d6ba06c96efd421e164299d3a7d386d207b4de7d5540f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d40f1ad2aea10244d887c97c12f4e16befa1ff49ae0c6bcebf6f06de5dc3cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a22ce61aa1c7035b6e010e4a938ea41cd424051e6f5d4b2769ccb048f6a2935"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b809625fb8242bf751cb250dfa153eaa1d6b390e6f3063d664ecb026de8a56d6"
    sha256 cellar: :any,                 arm64_linux:   "b4ffbe545630e95f47387d7426535c2428004b4f6213c948484466dfcba1b8db"
    sha256 cellar: :any,                 x86_64_linux:  "2e848fbdf55b613bbe23a435c477dfb873034d44f51bf42f821ce335b38966f7"
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
