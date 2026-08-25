class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.52.tar.gz"
  sha256 "3295f8d136e8cea15c3540236749e864bf82a1f4f6cb888fbd94a68ded99ddce"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b4601ef0d3a3aeb108d641bd9a25b20e1dc8c2f73bb7d6d65b3eb0bc3abac7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c0e6d675f89b5d32a8423d4ebd5d39aee23e9000ef519335171f01fa49c2cb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e13087a2293cc5db5b3d1e6d630f53369b181be7597aa54408652ac00f13b003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80fca041484ac92ae7644ac12a2737a8f17dd3830c2dba226104a68f011b63f0"
    sha256 cellar: :any,                 x86_64_linux:  "439a9f4e19f5878e70f83df687c09794e9d0691b204859fb0de855529b21c7c7"
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
