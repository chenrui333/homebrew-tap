class Frep < Formula
  desc "Fast find-and-replace CLI"
  homepage "https://github.com/thomasschafer/frep"
  url "https://github.com/thomasschafer/frep/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "f09e8ceb5e3f411b19548ce9b70c7bf9180dfc1ee75ee3c3784479adacc656d4"
  license "MIT"
  head "https://github.com/thomasschafer/frep.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06d06e47314bf3b3924447ebbe4baebe49a596df4a9072d7c0e435fad0d7372e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad2a95a5263b8929871aa6d085a26b9abffce3da337ff2561e911ecfdcaa3324"
    sha256 cellar: :any_skip_relocation, ventura:       "208683522aebdac6ddd9dfbb57b645719798fa5d1b104682ef0aa8a8451aa381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04fdd4c37916c2da7dbe746b1258d4adcdba70b72c88f7388b54ff033af9a44d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "frep")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frep --version")

    # skip test on Linux due to
    # `Error: frep does not support stdin input. Usage: frep <search> <replace>`
    return if OS.linux?

    (testpath/"input.txt").write "Hi, World!"
    system bin/"frep", "-d", testpath, "Hi", "Hello"
    assert_equal "Hello, World!", (testpath/"input.txt").read
  end
end
