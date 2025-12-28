class Gommit < Formula
  desc "Enforce git message commit consistency"
  homepage "https://github.com/antham/gommit"
  url "https://github.com/antham/gommit/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b4a94b0f2c1dc588df267e9f697c5b5b60b0a3668a2ef058c30e9983b8d6279d"
  license "Apache-2.0"
  head "https://github.com/antham/gommit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a8832435785a644aef8c977720ac03ed3421ea85338d69980e0330282fe2c22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c672bead76a8562e3bb29e2610b5307301872a7f9a5b7524d87f3bc450c0f41"
    sha256 cellar: :any_skip_relocation, ventura:       "f1df69a4de5945049945916f5eaa288d37112d75555d2a4648cfc5c76d47a3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257fabc10c9b0b307ee2be817e795be6abc945cdbc89ac4f2ffaffda41af7cbf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X gommit.appVersion=#{version}")

    generate_completions_from_executable(bin/"gommit", shell_parameter_format: :cobra)
  end

  test do
    (testpath/".gommit.toml").write <<~TOML
      [config]
      exclude-merge-commits=true
      check-summary-length=true
      summary-length=72
    TOML

    system bin/"gommit", "check"

    system bin/"gommit", "version"
  end
end
