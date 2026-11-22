class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "670e134b246ac80789f7fa39f84bd4b3a498423860b46e3c66e439da3f1fed64"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "9e89a507c1a7d8c7154d98a656d5b350a480627b0485ce21e29fc7615b170f2b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0294d4d5627d5f10c98cc8cd0cfa05ddfa07c0d0ddba5498ad66455c49eb131d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f327b2a1cd356c29dc8833d223d7f17b5502cc0147e8403a42f3aa93bb9c2c5c"
    sha256 cellar: :any,                 arm64_linux:   "fa48ea39f13b3b112c516e8cb1a16381f81846ddb6f5cc472a2da7d76067da1c"
    sha256 cellar: :any,                 x86_64_linux:  "a50d93010fab7d0ec268c61666cc1f121d47021e9f87feed217a1a3f3b2174cd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
