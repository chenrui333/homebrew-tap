class Kure < Formula
  desc "CLI password manager with sessions"
  homepage "https://github.com/GGP1/kure"
  url "https://github.com/GGP1/kure/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "e9e1fdd94fa152c0707e1526424d075e29840e5a53ad7b8b81ff28210fe98a48"
  license "Apache-2.0"
  head "https://github.com/GGP1/kure.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5395fc6b450ef40b92622466dbbf865a7731b5ce25c58b25cb1e1025f5868554"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5395fc6b450ef40b92622466dbbf865a7731b5ce25c58b25cb1e1025f5868554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6037207cda2a57f55c5b505541cd5002f5e48d889929f4874bfa52ddf7fc3ff"
    sha256 cellar: :any,                 x86_64_linux:  "d68aedfa94f7ff455c96eae517b4381dd4fe1e0412ed0f82ad377796685ea406"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kure", "--version"
    assert_match "Password:", shell_output("#{bin}/kure gen -l 20")
  end
end
