class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.30.tar.gz"
  sha256 "fa43f22264cc1fedab38d45294413e89b28cb1d54bd53f1ac194e6de0f1cafb3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c3ef29765f688173ed0373085db37e08536caa257fc805942c3e6850855fd1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa31852617e426ab054c80669f0da6ac1423b8e8a84572771abca56c8a280b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280a6aeb80a39f19bf78a7f2889199e327eb3582d208a2690427b0c780a0c266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23f4b6fa5b2f81413bee8e6668d643b1c44aeaeded6e80c35284d0777ae9f447"
    sha256 cellar: :any,                 x86_64_linux:  "aa2fe35710eb4af4ff14d5327a87d85794a029cb1a74453749f6d683b7e01da5"
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
