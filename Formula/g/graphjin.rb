class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.42.tar.gz"
  sha256 "d3e11905994436b227d81b14901d3cc5af0443649a9ff6d9126352b6dce5ce34"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94f707e3105fc264132656f12adfad2f9f606e2e85fffb40981c556e35995e21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dc264e961e4be0571bf9317b2d65ff1dd510fa03888c8e48f5453c3b00545a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7457aa35bd4c6816b97afbc27f6254d2197ad46f9b779bf285c6772243941d87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "febb57be20798c0ff49d6ee5e2a6e0ed0be20e4e02cb8dcdc6401dc4213db559"
    sha256 cellar: :any,                 x86_64_linux:  "4ba084d738a28406ea530cfea834df71b1917a305864ee4d2aafa61d75b14e2c"
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
