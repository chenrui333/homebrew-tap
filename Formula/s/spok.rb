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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c12bb42bb5403a8fcdadc238cc91a41ae3b8bcc41b50b79b323cf2373def22b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51062df357996280f96b3b0f7dd8988fe7ee4d2f081d2700117dfb5f29506f86"
    sha256 cellar: :any_skip_relocation, ventura:       "56a866c55ba35f8d71d2a6f4b5034b83b255095814d31fe5580ac4f37858c359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cfe788881f4fc3f360b8c98daa7cee418103199e978fd91e9d6b9c2c4df8e2"
  end

  depends_on "go" => :build

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
