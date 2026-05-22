class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.23.tar.gz"
  sha256 "31ba06afba4c7e9b101dbb598913db566561676cbc58c5429069756f27ff5dc6"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd1eb5f082f7dc531d6b914181b337f5b1fb767b44009a1619c4f8c881425099"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa659774d2ae67adaccb14bbb11d563ba7791222031aef8799195cf569e41f1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3911f8930beab1d1dca4ccb7ff6f278ec250b86cb53b21903e2ec42dc65f5d65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23de11b43c51d5eca5d03d084512aef536d7290b65b0ccef488ce4e615c77b77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b09988bbcd357d075f53de1a5bf388b41280579b670882aacc31c4d39c0513"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
