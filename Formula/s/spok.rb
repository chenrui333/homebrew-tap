class Spok < Formula
  desc "Lightweight build system and command runner"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/FollowTheProcess/spok/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4db1d868c9f7f70684aae4ab7c6e3195afa072f28fdd70656c69ee64a8cbcef7"
  license "Apache-2.0"
  head "https://github.com/FollowTheProcess/spok.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9670ff7e3bcb09d779b852261062288853bfd9433dece1d553d4ea75ec0e2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a9670ff7e3bcb09d779b852261062288853bfd9433dece1d553d4ea75ec0e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f276a44c7b1c7d611de256e92ed31385ae9a25d68c079bbe253a40df67669652"
    sha256 cellar: :any,                 x86_64_linux:  "fcdca3cab99ec6b9b6041e1210b673ce2e72f38f8d0e8357ad315ab1ad561355"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X go.followtheprocess.codes/spok/cli/cmd.version=#{version}
      -X go.followtheprocess.codes/spok/cli/cmd.commit=#{tap.user}
      -X go.followtheprocess.codes/spok/cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/spok"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spok --version 2>&1")

    system bin/"spok", "--init"
    assert_path_exists "spokfile"
    rm "spokfile"

    test_spokfile = testpath/"spokfile"
    test_spokfile.write <<~EOS
      task default() {
        echo "Hello, Spok!"
      }
    EOS

    assert_match "Hello, Spok!", shell_output("#{bin}/spok --spokfile #{test_spokfile}")
  end
end
