class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.18.tar.gz"
  sha256 "29e79d30c9623d48fde7cd719d95995a9c533f799ce9f080f05bf242a314ddc4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da96b0cb524fc73674feb6b32d06f97ceb677da84d8f27057fd52686bed972ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcd83f9cf8ddf590fbeafc30a11c2135c4f21c58bab2e3ae8932893872e4e63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eca6a771c1ffe14967037a6a3d361519d544578e6d3203823d8468ff28f01ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cfad4071a99bbf7f11c406943e2a18a0fb9996b08f2e1c2adb49904e4e3d5d0"
    sha256 cellar: :any,                 x86_64_linux:  "52fc85d8f9817b2529d560047778cc7edbefc8e8c38708e91ee3c3a02ea2f345"
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
