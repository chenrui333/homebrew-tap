class Claws < Formula
  desc "Terminal UI for AWS resource management"
  homepage "https://github.com/clawscli/claws"
  url "https://github.com/clawscli/claws/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "7df62070e4344facc55db631e51b6a153c83efed94b464c2abc1f8f75876b0ac"
  license "Apache-2.0"
  head "https://github.com/clawscli/claws.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aff734b6b7583be4e5f07f30df3f29c011bafec4e2616568be1d6b4335ea7140"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aff734b6b7583be4e5f07f30df3f29c011bafec4e2616568be1d6b4335ea7140"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aff734b6b7583be4e5f07f30df3f29c011bafec4e2616568be1d6b4335ea7140"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4003686295d0e5cb0177c243709cbd8eb4f502af9f6f8ea10eddba163945cedc"
    sha256 cellar: :any,                 x86_64_linux:  "b580ee74e20841fd7884a131e0107233c96d9916767c682ccdaa77ab5c0dd3fa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"

    system "go", "build", *std_go_args(ldflags:, output: bin/"claws"), "./cmd/claws"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claws --version")

    output = shell_output("#{bin}/claws --profile invalid/name 2>&1", 1)
    assert_match "Error: invalid profile name: invalid/name", output
    assert_match "Valid characters: alphanumeric, hyphen, underscore, period", output
  end
end
