class Cello < Formula
  desc "Service for running infrastructure as code software tools"
  homepage "https://github.com/cello-proj/cello"
  url "https://github.com/cello-proj/cello/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "77975a0b69e99ce6d71f5d7356ce5720ab35e81c86f3e491c36a1a0640db1205"
  license "Apache-2.0"
  head "https://github.com/cello-proj/cello.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f91200b4efeb1272a444ce7e37ba34f8cf5ba27e769f1e4e91ac32ec9b9995cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c0de3abcddb5a64462801dfce932c58503a21e4efed891c5f4a4dadc1f98c13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c92d61f00d0a87de4dcb6e0edf91dcd91a6f74958c4af11932c3cfde8c02e1c3"
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
