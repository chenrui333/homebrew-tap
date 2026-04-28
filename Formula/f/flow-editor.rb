class FlowEditor < Formula
  desc "Programmer's text editor"
  homepage "https://github.com/neurocyte/flow"
  url "https://github.com/neurocyte/flow/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1c69b69df208c92327641dd7b11fe293aa8d72cfc27f6b43d975114b60b52166"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6622f2986d289ef06f3028bb175140f12ea47c4fb9d3871406c650841505108b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1bac9d7880a91fec4d163d3369cba1d221c0b022be030dbb840223cecf11784"
    sha256 cellar: :any_skip_relocation, ventura:       "7648feadc85064bfc972ec047fa0aab4f751bebedc9c1c41fd09155008415959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da3a346eff9a3c9d50c7144e595a60c9e78fb07ba52915769e96ec89e0ef769d"
  end

  depends_on "zig" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      -Doptimize=ReleaseSafe
    ]

    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"flow", "--version"
  end
end
