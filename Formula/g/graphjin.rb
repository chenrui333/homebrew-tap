class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.2.7.tar.gz"
  sha256 "bab777c949a61ebc74c164d01c93855655f0275cec544badbd15c9450f02fc46"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8acfd60766cd8332dd901d8d6eea5a864f7de2e5ffb6b852809e0be0f5d92000"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79de24e84911ff2593f46348917d7c179239d55d472b22d494145e17e0cb66f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb996d02eed8a5060ec371283ee497de3d3b9bde3058545000970e8e3c21fa43"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
