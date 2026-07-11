class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.537",
      revision: "97104e0858543301e94a79aae01e6afe9ff333e0"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1695caeccf6914b65c910095a0df1d247765a1bcd28a2448339b2b099ee2fb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1695caeccf6914b65c910095a0df1d247765a1bcd28a2448339b2b099ee2fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1695caeccf6914b65c910095a0df1d247765a1bcd28a2448339b2b099ee2fb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45bfe1ec1d4cabdb48b5806d2f160c0ced35c7dc82a652b3412dfef3b439343b"
    sha256 cellar: :any,                 x86_64_linux:  "1c2c477cf2f06e8db6f657efe3748d166d0b7c9a145d6a125b46f1cc323f5d0b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
