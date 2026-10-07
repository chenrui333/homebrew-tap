class Tascli < Formula
  desc "Track tasks and records from the terminal"
  homepage "https://github.com/Aperocky/tascli"
  url "https://github.com/Aperocky/tascli/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e7ce1b10383724bac04ca8927895693945838e8bee5c43cf89c4ab458b65fb1d"
  license "MIT"
  head "https://github.com/Aperocky/tascli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e66230948176aa9f3be92219bee13f064ff2353ee56894728b310db2f6ff9aa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e925c48f00d6a1ea3e2d3c09a8d2209f265ae3eb12642fff9846c8578277f1da"
    sha256 cellar: :any,                 arm64_linux:   "a9081fa6d18027ab72df36673c4a39f1bada7d91dc1f9e16772b96a387d43f87"
    sha256 cellar: :any,                 x86_64_linux:  "296c7cc141b9872195f8f5c719e0d45c909899b8351f43eb984286e3f930b5f2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    task_content = "Write formula test"

    assert_match version.to_s, shell_output("#{bin}/tascli --version")

    system bin/"tascli", "task", "-c", "work", task_content, "today"

    output = shell_output("#{bin}/tascli list task -c work")
    assert_match task_content, output
    assert_match "work", output
    assert_path_exists testpath/".local/share/tascli/tascli.db"
  end
end
