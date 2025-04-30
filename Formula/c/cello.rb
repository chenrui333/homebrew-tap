class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "61c36993154c021a70331879b18e6b8bbd2a60bf9ad73afea6cec488ec675681"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2225ba07d0eb3edb6461f15a003ce79417b2a0df7a7b1cb27c02b5304968006e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d057db081fa65da9363728afd94991d04c221a3d807e7fca0bf8268744a1c058"
    sha256 cellar: :any_skip_relocation, ventura:       "12bc03db05ecb5eefa49ac9382b01afe3723ab3e68477c4f1dc751349f488763"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4908fa29604fc3e17b31f3f62e9d55ce91d1daafb0f7259972da8a32098fd02"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cli"

    generate_completions_from_executable(bin/"cello", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cello version")

    output = shell_output("#{bin}/cello list --project_name test --target_name test 2>&1", 1)
    assert_match "connection refused", output
  end
end
