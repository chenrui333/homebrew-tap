class Jarl < Formula
  desc "Just Another R Linter"
  homepage "https://jarl.etiennebacher.com/"
  url "https://github.com/etiennebacher/jarl/archive/refs/tags/0.4.0.tar.gz"
  sha256 "a7f88a222ad47356ac29059e39faa8f1b24cc46f311c0e759b03dff1aeb31b4a"
  license "MIT"
  head "https://github.com/etiennebacher/jarl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c96fb59291aaeb584b3c9abba74d91da6c9daf00c8b4f8c81cedc2c5f8b3586"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e65d20a6816116fecb4fbeabf49b6009ee8d35a23f6485ba71b4666cb475c361"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "376ff4505c97ef7fcb46861a0acb8abe639665ed5cb593b3143b9b31cb356d44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e275c19c171ea4b22e5c7d50ada360a33f1fec9cc88c8dd4c4143b57ffe2b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e92c5216e89be5e110844814ee2743a8cb7b9dc560fd410664a34ac211eaf57"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/jarl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jarl --version")

    (testpath/"test.R").write <<~R
      x = 1
      y <-2
      print( x +y )
    R

    output = shell_output("#{bin}/jarl check --select assignment #{testpath}/test.R 2>&1", 1)
    assert_match "Found 1 error", output

    output = shell_output("#{bin}/jarl check --select assignment --fix --allow-no-vcs #{testpath}/test.R")
    assert_match "All checks passed!", output
  end
end
