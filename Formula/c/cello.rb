class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.22.1.tar.gz"
  sha256 "7e6c0295a8fc7c1f2f4cf9bbb7fd21710da7f605bdb472162f1742246e0e33b1"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95cfb944ddd65e4a34b18ab4b70b8c3f34b7a16a8dc7573bfa9ae5e909ef8a1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95cfb944ddd65e4a34b18ab4b70b8c3f34b7a16a8dc7573bfa9ae5e909ef8a1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95cfb944ddd65e4a34b18ab4b70b8c3f34b7a16a8dc7573bfa9ae5e909ef8a1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "245ff3b95b88539ef6dccdec47829406cf6a6970bb035b2237622e465f267d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd05fd4af14b8a9b7ac4f5df4c6b70989840d079ecf46aa125901814a54c8bbc"
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
