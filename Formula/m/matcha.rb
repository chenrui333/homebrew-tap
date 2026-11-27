class Matcha < Formula
  desc "Terminal email client built with Bubble Tea"
  homepage "https://matcha.email/"
  url "https://github.com/floatpane/matcha/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3d169ec57d4019f647af3b9991acdc512312b75dc2ba0719c65fccddbf518c84"
  license "MIT"
  head "https://github.com/floatpane/matcha.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "51bdc7cd1ec1c643a572d8e17f950c335a81725bcd300b7ad715ebb3757f04b1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "865d058ae249ba1d934ba928727c90def3a3f9b1d4c63d04ac3f275297a1c3b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ac440d01b46ce1204fb162119ae9a03d6d8816918eb41f8727b6aac25a16852"
    sha256 cellar: :any,                 arm64_linux:   "48e45bb22e873ce12496ca15f41ab9492d5f51190aebf3c90ec1dcc7746afb77"
    sha256 cellar: :any,                 x86_64_linux:  "6fe6f2843e346ea29f227da732f9f28c2ddf49e4df6b347c77c09a35ae710f5e"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "pcsc-lite"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args
  end

  test do
    output_file = testpath/"matcha-test.log"
    pid = fork do
      Process.setsid
      $stdin.reopen(File::NULL)
      $stdout.reopen(output_file, "w")
      $stderr.reopen(output_file, "a")
      exec bin/"matcha"
    end
    Process.wait(pid)

    output = output_file.read
    assert_match "Alas, there's been an error", output
    assert_match "/dev/tty", output
  end
end
