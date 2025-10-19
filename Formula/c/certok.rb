class Certok < Formula
  desc "CLI to check the validity and expiration dates of SSL certificates"
  homepage "https://github.com/genuinetools/certok"
  url "https://github.com/genuinetools/certok/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "e874b7a04781ca5b056a53f3a7082ab91bd68e3841789e6d9aeab90ac5976149"
  license "MIT"
  revision 1

  livecheck do
    skip "no recent releases"
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e976d7d3251df2342ffe24273623eaf4cdefd5ea72a1db949831ee8bafaed4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e976d7d3251df2342ffe24273623eaf4cdefd5ea72a1db949831ee8bafaed4fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e976d7d3251df2342ffe24273623eaf4cdefd5ea72a1db949831ee8bafaed4fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "740b9aa9fd5f54b9e9a5f4a0bae8933f226cb632f4bc9a20a8f1a7f099c19f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "454bc5b0bbcf3897a34a99ce9de2b3464dca4d2b12c67dc2a5b3578f2f53f24b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/genuinetools/certok/version.VERSION=#{version}
      -X github.com/genuinetools/certok/version.GITCOMMIT=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/certok version")

    hosts_file = testpath/"hosts.txt"
    hosts_file.write("example.com")
    output = shell_output("#{bin}/certok #{hosts_file}")
    assert_match "DigiCert Global G3 TLS ECC SHA384 2020 CA1  ECDSA-SHA384", output
  end
end
