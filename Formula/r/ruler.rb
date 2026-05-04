class Ruler < Formula
  desc "Tool to abuse Exchange services"
  homepage "https://github.com/sensepost/ruler"
  url "https://github.com/sensepost/ruler/archive/refs/tags/2.5.0.tar.gz"
  sha256 "e7344c60c604fa08f73dd30978f6815979cc26ca78bca71e132d0c66cc152718"
  license "CC-BY-NC-SA-4.0"
  head "https://github.com/sensepost/ruler.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4e91130fc2a1e9a597504c9220664e52fb89d265f9c5b28bdbffbb2def5a30c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4e91130fc2a1e9a597504c9220664e52fb89d265f9c5b28bdbffbb2def5a30c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4e91130fc2a1e9a597504c9220664e52fb89d265f9c5b28bdbffbb2def5a30c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a70495a89366734ac469f645c1e74f0ead64a947e3335fde4496aec32ac7e2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164b8ed8a4715a9670af51b751dd297720f61e4463fc95406648647641490a1b"
  end

  depends_on "go" => :build

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
