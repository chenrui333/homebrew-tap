class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e1da39f117ed7ccdd2a4ed0579e7a22b09e4572b9e8bc6f53d6978e9366b0f81"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea194bb735dcac6709b3bd9130ab8b6bb83b3d84f9eacd80e375e696fca86ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f38c8dbbe82f1bde9aa5c87a9ecfe941c04c978ac7f1471dac2b3ea998e2984c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77b9ad76d815d4d5a4b26c9364a63c8947c6a4b64d37b0b87da6bdc26853007b"
    sha256 cellar: :any,                 arm64_linux:   "bc633fdc8b378538e77c5393fd144c4b7701264d4a461828461961b415334725"
    sha256 cellar: :any,                 x86_64_linux:  "decd6637b43b9668ae066bc6e550dd4a7acc78e05160cf2e26be1ffbdbcd0d41"
  end

  depends_on "rust" => :build

  def install
    ENV["CARGO_TARGET_DIR"] = buildpath/"target"

    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-client")
    system "cargo", "install", *std_cargo_args(path: "crates/taskbook-server")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tb --version")

    system bin/"tb", "--cli", "--taskbook-dir", testpath, "--task", "Ship formula"
    output = shell_output("#{bin}/tb --cli --taskbook-dir #{testpath} --list pending")
    assert_match "Ship formula", output
  end
end
