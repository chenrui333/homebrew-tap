class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "77975a0b69e99ce6d71f5d7356ce5720ab35e81c86f3e491c36a1a0640db1205"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c353f973a908969fff254f88af9307ad2aaaced6c762a08237b9ef4edceeddfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6a64097e74b9ec5322b5aee235e09548032e7190cb11e37b37b03324218b87c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e96afee38b025b9b4cbb2ae47b967cc86ea655be80fa89269cdec88199bb3c0"
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
