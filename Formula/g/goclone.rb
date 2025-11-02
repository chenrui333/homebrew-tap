class Goclone < Formula
  desc "Website Cloner"
  homepage "https://github.com/goclone-dev/goclone"
  url "https://github.com/goclone-dev/goclone/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "1e005a045b3d2f5d4d0a7154f4552e537900c170256b668cc73aeac204d9defa"
  license "MIT"
  head "https://github.com/goclone-dev/goclone.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d78e58f4a67331af19802810ea3945b58f364f1d798f4fca84806d3d9b82140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d78e58f4a67331af19802810ea3945b58f364f1d798f4fca84806d3d9b82140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d78e58f4a67331af19802810ea3945b58f364f1d798f4fca84806d3d9b82140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0d981cf95a540abe9f8f1070a8795dfd1d76a64e5c49bd891ce37e768db3a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db3a5fad6c21fd5a251b10bbb699861498148216561868ef42327590f0ce64a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goclone"

    generate_completions_from_executable(bin/"goclone", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goclone version")

    system bin/"goclone", "https://example.com"
    assert_path_exists testpath/"example.com"
  end
end
