class Ruler < Formula
  desc "Tool to abuse Exchange services"
  homepage "https://github.com/sensepost/ruler"
  url "https://github.com/sensepost/ruler/archive/refs/tags/2.5.0.tar.gz"
  sha256 "e7344c60c604fa08f73dd30978f6815979cc26ca78bca71e132d0c66cc152718"
  license "CC-BY-NC-SA-4.0"
  head "https://github.com/sensepost/ruler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a111706c71fb66c9b597d06bfc89848dab82318c8d8527410cf7ab999f0f298"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a111706c71fb66c9b597d06bfc89848dab82318c8d8527410cf7ab999f0f298"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de5353fadc6adf206af29106298aeabe816eedd93fbd058958560a6e3d281bab"
    sha256 cellar: :any,                 x86_64_linux:  "711a416035e00703fb8e7a11c33fcfd5cb343346b094a975c358133f3d50ea0b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    # Pre-1.17 go.mod omits indirect deps the build needs; fetch the full module graph.
    system "go", "mod", "download", "all"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    test_config = testpath/"config.yml"
    test_config.write <<~EOS
      username: ""
      email: ""
      password: ""
      hash: ""
      domain: ""
      userdn: "/o=First Organization/ou=Exchange Administrative Group(FYDIBOHF23SPDLT)/cn=Recipients/cn=0003BFFDFEF9FB24"
      mailbox: "0003bffd-fef9-fb24-0000-000000000000@outlook.com"
      rpcurl: "https://outlook.office365.com/rpc/rpcproxy.dll"
      rpc: false
      rpcencrypt: true
      ntlm: true
      mapiurl: "https://outlook.office365.com/mapi/emsmdb/"
    EOS

    output = shell_output("#{bin}/ruler --config #{test_config} check 2>&1", 1)
    assert_match "Missing username and/or email argument.", output
  end
end
