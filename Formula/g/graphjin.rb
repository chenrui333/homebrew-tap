class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.30.tar.gz"
  sha256 "dc760764a383da07271e67a02205020bc864ad3706b7766d5c4b2e175b223e6a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e40e6729b3a989af24fb35d38c51b6005ba032857df719fe28fe9aa017f902"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef69a85ed6b8a059d592aacadc32e5f79a33c26e1fd6379fbfd836b79bd09215"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2349f1ded345ac24d7aa2ade269c12c542863ab0b74e480476f58e9ca1ec54dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caa846a191b9af6768a658b13da5c761f2e13e99412d4f98d8198e6c46eb9c57"
    sha256 cellar: :any,                 x86_64_linux:  "03b44af8ab38693fce7b95f1e037e5f1f3f1ab9ad9e631f7cb1b13147bf94c11"
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
