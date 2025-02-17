# framework: urfave/cli
class Lintnet < Formula
  desc "General purpose linter for structured configuration data powered by Jsonnet"
  homepage "https://lintnet.github.io/"
  url "https://github.com/lintnet/lintnet/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "c0022f31f7c789e2a7fe07a0ea174669bce2b87d6bd398d5448e00b8d15699a9"
  license "MIT"
  head "https://github.com/lintnet/lintnet.git", branch: "main"

  depends_on "go" => :build

  # fix version typo
  patch do
    url "https://github.com/lintnet/lintnet/commit/ed1fea6ae5ed0e2a92d4ab085772cd9a667359b5.patch?full_index=1"
    sha256 "234457c4b374471221c75270a32cdcea892d0ea11f7247aadc81102ed5dc4e8f"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lintnet"

    generate_completions_from_executable(bin/"lintnet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lintnet version")
    assert_match version.to_s, JSON.parse(shell_output("#{bin}/lintnet info"))["version"]

    system bin/"lintnet", "init"
    assert_match "A configuration file of lintnet", (testpath/"lintnet.jsonnet").read
  end
end
