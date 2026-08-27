class Aim < Formula
  desc "Command-line download/upload tool with resume"
  homepage "https://github.com/mihaigalos/aim"
  url "https://github.com/mihaigalos/aim/archive/refs/tags/1.9.0.tar.gz"
  sha256 "66b24fe3194f9538465b47c9f303e2b787e46490582e16442ef550245dbc75d6"
  license "MIT"
  head "https://github.com/mihaigalos/aim.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "926ee46eff352e89e401ba7b4fe4cf1735b0326e05b95c76b36b6ab055e71723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7687a76ebb7ebf9699e3aa48abd758975fcfc360a6253723052b8f13084741e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2c7aeadcaa62e6fc18188f328dd3cdbd15deb1f2f76230e89af992d919dd3a"
    sha256 cellar: :any,                 arm64_linux:   "d72b0c1440ac90576991d37b4c91e32b87bbd0b7a4165234360584c6d8551cce"
    sha256 cellar: :any,                 x86_64_linux:  "522836e951d283effae7d062eb52f6a79ff598f95e0b2559f43ea0d6332b3dd3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aim --version")

    output_log = testpath/"output.log"
    pid = spawn bin/"aim", "test", [:out, :err] => output_log.to_s
    sleep 2
    assert_match "Serving on:", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
