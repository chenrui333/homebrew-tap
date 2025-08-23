class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/3.2.0.tar.gz"
  sha256 "72609300de8dec2f0cfdd9f94591440975591f4f939e9b2b788c3117128fbcfd"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44928a50854f52c9f4c54346c6849793b8c6b643b01a6449e62858c319aef979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab89d548fc9889179b61ae383f88198bdafe96882bbc4383d7d4b7e76d2eb90"
    sha256 cellar: :any_skip_relocation, ventura:       "f8d23e97f70c2b1f2e0cb579216d3acab6a50d8b6babf5dd261e7ecb6753d3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acb7d44eb25002e631e937a11416f37ebcf462942d40cc49ec9f2274dc7340c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")
    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
