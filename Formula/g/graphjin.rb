class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.19.2.tar.gz"
  sha256 "a83b3a40a0188145c68b071607ea237a32899ad4604ba622d354286d2bbd0f52"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789e6c2914b789a01b6a11797ac138f6487c422bb31d39c7561fcab2ebd5f294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34d9a8c7ffe7e7b325a1db8f087c020c91db3795c107838ec55da7d9ef0b715b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f2559142fa701cd6c99204093c19414c0c1643dce0a1361d3a25b1ddc7f625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87aa284524a0750fe7b205315ebf581534f910e7ba5eb5dc94294288bc9c5c68"
    sha256 cellar: :any,                 x86_64_linux:  "5cc9f1ce6fe7f66854352d91df2749899d5b3f37753cf43ecc097dd5f66ab516"
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
