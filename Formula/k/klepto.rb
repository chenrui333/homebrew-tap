class Klepto < Formula
  desc "Tool for copying and anonymising data"
  homepage "https://github.com/hellofresh/klepto"
  url "https://github.com/hellofresh/klepto/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "f62bc59204db301f0f1122e4a9429019afdbe23ac91903252c0b4cf78309507d"
  license "MIT"
  head "https://github.com/hellofresh/klepto.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d98568f1dcdaab3cb84c7d71a42d2f32a01197c953a82c952d68adb8ee63e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d98568f1dcdaab3cb84c7d71a42d2f32a01197c953a82c952d68adb8ee63e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0243ec6c93a49e38b89590a35a639d055819683ddccb917403f14196ffc5594a"
    sha256 cellar: :any,                 x86_64_linux:  "9ce60f90211d0c80e91cf8e85d95c698b056cbde9a3cca10cea2adc01121fd53"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/hellofresh/klepto/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"klepto", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/klepto --version")

    assert_match "Created .klepto.toml", shell_output("#{bin}/klepto init 2>&1")
    assert_match "ActiveUsers = \"users.active = TRUE\"", (testpath/".klepto.toml").read
  end
end
