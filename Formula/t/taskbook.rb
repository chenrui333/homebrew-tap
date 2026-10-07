class Taskbook < Formula
  desc "Tasks, boards & notes for the command-line habitat"
  homepage "https://taskbook.sh"
  url "https://github.com/taskbook-sh/taskbook/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e1da39f117ed7ccdd2a4ed0579e7a22b09e4572b9e8bc6f53d6978e9366b0f81"
  license "MIT"
  head "https://github.com/taskbook-sh/taskbook.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d23499bc7cc0a6baab45d4bc565607654049585737cfa3cb6108d7ebd355a2ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40829a3bd9effbc88adf8af2d3c777d44cab5116ad16cd2c99d0df4721293fb1"
    sha256 cellar: :any,                 arm64_linux:   "000bf86e80159e243f9ecda1e5d89d3ecd65e425943b49234f84b264a64808d4"
    sha256 cellar: :any,                 x86_64_linux:  "318711639ac2ed4dc297245b43df79906123549cd3aab794dd35c018ba2b4f70"
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
