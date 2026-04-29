class Ssm < Formula
  desc "Terminal Secure Shell Manager"
  homepage "https://github.com/lfaoro/ssm"
  url "https://github.com/lfaoro/ssm/archive/refs/tags/0.4.2.tar.gz"
  sha256 "6a2226884509377b873831efc4e4103c007e3e59283baf9598c3bfbc4f3e96b8"
  license "BSD-3-Clause"
  head "https://github.com/lfaoro/ssm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c3880f7675606bd921ae31597a3ce7f12713de75f8776a5ec22e971eca0e467"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3880f7675606bd921ae31597a3ce7f12713de75f8776a5ec22e971eca0e467"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c3880f7675606bd921ae31597a3ce7f12713de75f8776a5ec22e971eca0e467"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f608e1f1f5e924896ddbf7c1b7fb2fd343cd4adbbf7f0871b2a1dd8bd113620c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11019d8e202e8be663acb62daf824921ed21fa822960b852288e763e3e5b91a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.BuildVersion=#{version} -X main.BuildDate=#{time.iso8601} -X main.BuildSHA=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ssm --version")
  end
end
