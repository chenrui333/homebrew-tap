class Gommit < Formula
  desc "Enforce git message commit consistency"
  homepage "https://github.com/antham/gommit"
  url "https://github.com/antham/gommit/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "b4a94b0f2c1dc588df267e9f697c5b5b60b0a3668a2ef058c30e9983b8d6279d"
  license "Apache-2.0"
  head "https://github.com/antham/gommit.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X gommit.appVersion=#{version}")

    generate_completions_from_executable(bin/"gommit", "completion")
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
