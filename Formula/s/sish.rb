class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.21.0.tar.gz"
  sha256 "dfb114700707c7b90cc860395a8a18a6610fb6c60f76b0d02fefa4460b2b3bbe"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b85125ac79ed6a664541a132063b3fa8a171d173fc1582816fa94f31f7bdea0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b85125ac79ed6a664541a132063b3fa8a171d173fc1582816fa94f31f7bdea0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b85125ac79ed6a664541a132063b3fa8a171d173fc1582816fa94f31f7bdea0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe208da73e56eff67655d43ae33ec4d1ba289a975090ab51881b20456fa2c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d10e33f9a9362e83d102c32a0474ea1e249f01e51a0a698a22f4b38eb4ec9744"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/antoniomika/sish/cmd.Version=#{version}
      -X github.com/antoniomika/sish/cmd.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sish --version")
  end
end
