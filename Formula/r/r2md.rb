class R2md < Formula
  desc "Entire codebase to single markdown or pdf file"
  homepage "https://github.com/skirdey-inflection/r2md"
  url "https://static.crates.io/crates/r2md/r2md-0.4.4.crate"
  sha256 "a825301857fbc1d40b98910a1b71c08798ebf752ec0dec34b2e726199b448f92"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d418b7515f35a0f4b6de6326ef7f1306b5dae4f13516aa6f7947d65a23df074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16f601a70a9f680c89fbed8282e3aad690e58bd0cafa06ced7f5e88f0cb759d"
    sha256 cellar: :any,                 arm64_linux:   "d69ee6f31b6c020ed4af651acf242070c3c96d0b37b98fe0cf28a43545de6a9a"
    sha256 cellar: :any,                 x86_64_linux:  "104bbc428f5196d7301352823a530fb0a974b2840d9b27134f052509f764e9fd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/r2md --version")

    (testpath/"test.rs").write <<~RUST
      fn main() {
          println!("Hello, world!");
      }
    RUST

    output = shell_output("#{bin}/r2md #{testpath}")
    assert_match "# r2md Streaming Output", output
  end
end
