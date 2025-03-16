class Scrt < Formula
  desc "Secret manager for developers, sysadmins, and devops"
  homepage "https://scrt.run/"
  url "https://github.com/loderunner/scrt/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "72ac4c594e8c89b43d679118d571f2726a86628b324b33486fba4331b1dc39de"
  license "Apache-2.0"
  head "https://github.com/loderunner/scrt.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # upstream bug report, https://github.com/loderunner/scrt/issues/1048
    # generate_completions_from_executable(bin/"scrt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrt --version")

    output = shell_output("#{bin}/scrt init --storage=local --password=p4ssw0rd --local-path=store.scrt")
    assert_match "store initialized", output
    assert_path_exists testpath/"store.scrt"
  end
end
