class Ddev < Formula
  desc "Docker-based local PHP+Node.js web development environments"
  homepage "https://ddev.com/"
  url "https://github.com/ddev/ddev/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "3a78e189d5a61f6d949c5a7329faf9190920120aab37bb74fc0a5abd0be23773"
  license "Apache-2.0"
  head "https://github.com/ddev/ddev.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad930c6105979ebc77986b1fefd001cfeafa013d6ffb984e4a444b5ad89ff1b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad930c6105979ebc77986b1fefd001cfeafa013d6ffb984e4a444b5ad89ff1b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad930c6105979ebc77986b1fefd001cfeafa013d6ffb984e4a444b5ad89ff1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d30ea3f06948d560b4da08359edc7f45fd032bce934d17113e9d1383c66418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913f3ca9d9d83ceb124890d6d1b215cd51eb7ad78f5adb8c2a11d89122112e16"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = "-s -w -X github.com/ddev/ddev/pkg/versionconstants.DdevVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/ddev"

    # generate_completions_from_executable(bin/"ddev", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match version.to_s, shell_output("#{bin}/ddev --version")

    assert_match "failed to connect to the docker API", shell_output("#{bin}/ddev list 2>&1", 1)
  end
end
