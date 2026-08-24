class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.51.tar.gz"
  sha256 "5e4ed230382581590dd228cb3d87cc8f349ee032ea61cee600e63a19e7e88718"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "819048e6df4fff73a3b5fe1a88786224c447e18ff6d8aec0f711df17cdd5e588"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1d280e05917a4b848ac9d593cdd2e079fa09a280558b1349ba902c8b16aa5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "496146e51fc7e1421feeed9c933395de178a6461b43b82b68d5649a43365fe94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21f0099ab1e83d8b93feee15604b4606a7c3b18600119458feb377afdbe610f7"
    sha256 cellar: :any,                 x86_64_linux:  "719c9c20f5aa6eb33482c4ecb2fb2452e73bbb64617fb21974337018581686bd"
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
