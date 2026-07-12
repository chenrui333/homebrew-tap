class Burn < Formula
  desc "See what's burning your Kubernetes budget"
  homepage "https://github.com/tanrikuluozlem/burn"
  url "https://github.com/tanrikuluozlem/burn/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "95a8ec39ac8785f53f5bef1614d46297ecb94e166d0766b7fc79c1b01846e6c6"
  license "Apache-2.0"
  head "https://github.com/tanrikuluozlem/burn.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5dfd5450d2292ea9778b749ad1c5a2c63803d95c62d5c6039e4c17083e82806c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dfd5450d2292ea9778b749ad1c5a2c63803d95c62d5c6039e4c17083e82806c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dfd5450d2292ea9778b749ad1c5a2c63803d95c62d5c6039e4c17083e82806c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fde75a8a2da496e094cacefc433c165c2c95d9d47bfb284eaf12cba9db9fc9a"
    sha256 cellar: :any,                 x86_64_linux:  "5291b69fba83952a9054ecb92f18d2b0d55201e66f5941efe01bc667e1f9479f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/burn"

    generate_completions_from_executable(bin/"burn", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/burn version")

    output = shell_output("#{bin}/burn analyze --ai 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
