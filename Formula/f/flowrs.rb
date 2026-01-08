class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "ec2f5f04ec77d7c63cf40da03570d2593ba23a60e835c94102efa9b2caaa9aa5"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e761a66ab068999db7c9e0b5e69f54b70db85ef364475b62755a36b2b274712"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34fe3236ae1a5d549c6d57922eb9788bd2ff241ffdf0538193d592574a9873f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7ac38aa6992129bbe9ab9e402df8cf3ba8204c064dd407cf81e03bce2e007b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82c7ee6390c72f8b0334fc6cfc42527fc51fdac84c2492d38b97d24a036ecc31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2306aabcbc1ef7c1acb5e2417bd73f3fd26dfe46a3256a922d9251091732c0bb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
