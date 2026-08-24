class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.48.tar.gz"
  sha256 "894e981802debb9e51f275e59ef1c488b6720e860cb022110d9c8eb4474e7871"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cd723adbcf4ca172e86aef5bf2cb6102c40c7fa93c8373f72fee71438c4ace6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812bff9d6657587fcbdb1795e8c0fa28dcd48f798fbd3e9ca71d60babe2f77ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13146e0ae5ea926cfabdff13236578ed4dc6e706e885ff399cc4e1119449025"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1abcee8f2657d3682ef317e8a3e1a79437ecd5cb317d321dcb1c55d00ebc3d8c"
    sha256 cellar: :any,                 x86_64_linux:  "959e1cb96d7dd0acb51bf84bd19a252fccd320e248e321241b96ee5c5a1a1906"
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
