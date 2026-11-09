class Rovr < Formula
  include Language::Python::Virtualenv

  desc "Post-modern terminal file explorer"
  homepage "https://github.com/NSPC911/rovr"
  url "https://github.com/NSPC911/rovr/archive/refs/tags/v0.10.2.post1.tar.gz"
  version "0.10.2.post1"
  sha256 "a44f2d542fde0545269bd9575b65a9e1c7289f3dc8998cf3766453ae67db021b"
  license "MIT"
  revision 1
  head "https://github.com/NSPC911/rovr.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "010f80a722eff27f3aac327dcab05bab7b884520a280e490cd0081146b11f0ad"
    sha256 cellar: :any, arm64_sequoia: "8a01ed57cf2a338b9faa3a2965736e87456e0d0ca3997633d7279da41bf5e5a9"
    sha256 cellar: :any, arm64_linux:   "c6a559250a40d05bddd65a419b404bcea9727023012aa62b2d86c9b06fae02c1"
    sha256 cellar: :any, x86_64_linux:  "7003f2f367a7330216a9221e083e5ea51f2be039bf5f3cc4fd5fe6ef959fc8ee"
  end

  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "pillow" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "xz" # for uv-build

  on_linux do
    depends_on "bzip2" # for uv-build
  end

  pypi_packages exclude_packages: %w[pillow],
                extra_packages:   %w[
                  calver flit-core hatch-vcs hatchling packaging pathspec pluggy poetry-core setuptools
                  setuptools-scm textual-speedups tomlkit trove-classifiers uv-build==0.12.23 vcs-versioning wheel
                ]

  resource "calver" do
    url "https://files.pythonhosted.org/packages/4a/96/0c57e3e228ffc54074867406b659b197678674f1f0bf600d114965289834/calver-2025.10.20.tar.gz"
    sha256 "c98b376c2424642224d456b2f70c51402343e008c63d204634665e1a2a2835f5"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/20/b5/23b216d9d985a956623b6bd12d4086b60f0059b27799f23016af04a74ea1/fastjsonschema-2.21.2.tar.gz"
    sha256 "b1eb43748041c880796cd077f1a07c3d94e93ae84bba5ed36800a33554ae05de"
  end

  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/69/59/b6fc2188dfc7ea4f936cd12b49d707f66a1cb7a1d2c16172963534db741b/flit_core-3.12.0.tar.gz"
    sha256 "18f63100d6f94385c6ed57a72073443e1a71a4acb4339491615d0f16d6ff01b2"
  end

  resource "hatch-vcs" do
    url "https://files.pythonhosted.org/packages/6b/b0/4cc743d38adbee9d57d786fa496ed1daadb17e48589b6da8fa55717a0746/hatch_vcs-0.5.0.tar.gz"
    sha256 "0395fa126940340215090c344a2bf4e2a77bcbe7daab16f41b37b98c95809ff9"
  end

  resource "hatchling" do
    url "https://files.pythonhosted.org/packages/f6/97/b5312f01a8c6daf729a9d272dd442e0c546dbcc630495788786c4b567ed0/hatchling-1.32.4.tar.gz"
    sha256 "c4468f73144c054d2aab4ef0f0378c43b9878bf07f8ffd6b79690e970d375f07"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/ba/66/a3921783d54be8a6870ac4ccffcd15c4dc0dd7fcce51c6d63b8c63935276/humanize-4.15.0.tar.gz"
    sha256 "1dd098483eb1c7ee8e32eb2e99ad1910baefa4b75c3aff3a82f4d78688993b10"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multiarchive" do
    url "https://files.pythonhosted.org/packages/66/82/f5ec692b88de8c6d63ee782ced1c8124c1f26846062e94129d8e904ed12a/multiarchive-0.2.2.tar.gz"
    sha256 "c20dd8b2a07b425040019909ecc6d47286e3cbbf121ab9edc3b4ee0fa236533c"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pathvalidate" do
    url "https://files.pythonhosted.org/packages/fa/2a/52a8da6fe965dea6192eb716b357558e103aea0a1e9a8352ad575a8406ca/pathvalidate-3.3.1.tar.gz"
    sha256 "b18c07212bfead624345bb8e1d6141cdcf15a39736994ea0b94035ad2b1ba177"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/19/56/8d4c30c8a1d07013911a8fdbd8f89440ef9f08d07a1b50ab8ca8be5a20f9/platformdirs-4.9.4.tar.gz"
    sha256 "1ec356301b7dc906d83f371c8f487070e99d3ccf9e501686456394622a01a934"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/42/b5/50f1fda26c4fe5b1d6ce5cdf0391bdfa1ca12fdcb8ad68344d5cf678fc90/poetry_core-2.5.0.tar.gz"
    sha256 "81d04c9253b19d0604718268d781867c8f7b2128e5b25bbf1e84141eec6b89c4"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pytrash" do
    url "https://files.pythonhosted.org/packages/bd/29/fc6bc993281e02967da4bb989446b3db384f5582c457dc5ecf81361b011e/pytrash-0.5.0.tar.gz"
    sha256 "7d76a18430d67b45cc1d0eb9132db1cdafa1cdb055bc858da0b696095e2a1245"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/26/3f/3118a797444e7e30e784921c4bfafb6500fb288a0c84cb8c32ed15853c16/rarfile-4.2.tar.gz"
    sha256 "8e1c8e72d0845ad2b32a47ab11a719bc2e41165ec101fd4d3fe9e92aa3f469ef"
  end

  resource "resvg-py" do
    url "https://files.pythonhosted.org/packages/2a/64/a24f8f29d8bf158e01f6ccad68a1366afd922dc0f0977cbd0c0aaa7a22f2/resvg_py-0.5.0.tar.gz"
    sha256 "6d3bf8e866b4e129524d9432a809138b2d100931d8d635bc81294002abcdfd46"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fb/d2/8920e102050a0de7bfabeb4c4614a49248cf8d5d7a8d01885fbb24dc767a/rich-14.2.0.tar.gz"
    sha256 "73ff50c7c0c1c77c8243079283f4edb376f0f6442433aecb8ce7e6d0b92d1fe4"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "setuptools-scm" do
    url "https://files.pythonhosted.org/packages/85/d8/fc143f88819ccf10ba2388ba86732ee2de193e578234e25a783f6cc14bf7/setuptools_scm-10.3.4.tar.gz"
    sha256 "a69f28bfc245608781205e912faae437c2b2165773afa4e7b979d77447a69dd2"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-autocomplete" do
    url "https://files.pythonhosted.org/packages/1e/3a/80411bc7b94969eb116ad1b18db90f8dce8a1de441278c4a81fee55a27ca/textual_autocomplete-4.0.6.tar.gz"
    sha256 "2ba2f0d767be4480ecacb3e4b130cf07340e033c3500fc424fed9125d27a4586"
  end

  resource "textual-drivers" do
    url "https://files.pythonhosted.org/packages/b7/c5/6553fda1ab2846e9fb0fdb116b3ec58aa070a7c9d44d09db4545216654f1/textual_drivers-0.10.4.tar.gz"
    sha256 "3b76952e679ef1cb054538e49055721befa4534207b452bdbf102d23c00d7fb0"
  end

  resource "textual-image" do
    url "https://files.pythonhosted.org/packages/10/77/b2128ced69556bfbb8e1c19d8f013e621cf12531eaba4e9b09e1cfa81e37/textual_image-0.13.2.tar.gz"
    sha256 "8ca0cee2bfcd7734de5b16a1936da226b77b745e28830d9cf2bc202cb70e43ee"
  end

  resource "textual-speedups" do
    url "https://files.pythonhosted.org/packages/d4/73/bba3e9feae9ca730c32122306ddac61278a8bc47633346eddad9d52a435d/textual_speedups-0.2.1.tar.gz"
    sha256 "72cf0f7bdeede015367b59b70bcf724ba2c3080a8641ebc5eb94b36ad1536824"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/82/30/31573e9457673ab10aa432461bee537ce6cef177667deca369efb79df071/tomli-2.4.0.tar.gz"
    sha256 "aa89c3f6c277dd275d8e243ad24f3b5e701491a860d5121f2cdd399fbb31fc9c"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/bf/93/af436dfaa845cab5d96f0adbc1e4f3730532d37fa249e4eb796fb1d7fc82/trove_classifiers-2026.9.21.13.tar.gz"
    sha256 "0a9ebc8d4e2f3e8a22848c5258033035bec17a3012ac3fea16dbaa764489eb71"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "uv-build" do
    # The complete workspace is needed for locked, offline Cargo metadata.
    url "https://github.com/astral-sh/uv/archive/refs/tags/0.12.23.tar.gz"
    sha256 "662023e7453d40c2e751ddc9f0c9dc27e09f27324ca7e81249b3d15a5e5e364f"
  end

  resource "vcs-versioning" do
    url "https://files.pythonhosted.org/packages/6f/a0/6977bb418312ad30f27e522c5040604d4bbf7e40ccd5a11d333afe549354/vcs_versioning-2.5.0.tar.gz"
    sha256 "956a796e31f80fe714d219d6d1df15a6bf247d10f6d851bf4b98279d0a42da55"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/d0/20/50ed6bdf27dec98b568a8ae25dc599f35baa3d9709f9e83fd1edb56b9a90/wheel-0.48.0.tar.gz"
    sha256 "94800765601e9171bf5d58d066e640662842bcedcbab982b2c90787a2c987322"
  end

  resource "uv-build-legacy" do
    # pytrash and textual-drivers require the separate 0.11 backend family.
    url "https://github.com/astral-sh/uv/archive/refs/tags/0.11.28.tar.gz"
    sha256 "556c6cb42a2101c690704b08d0d3c5d596ea94e69353a820664568f0fcd62fd4"

    livecheck do
      skip "Pinned build backend for pytrash and textual-drivers"
    end
  end

  deny_network_access!

  def fetch
    # maturin/PyO3 run offline `cargo metadata`, which needs crates for all targets.
    %w[resvg-py textual-speedups uv-build uv-build-legacy].each do |name|
      resource(name).stage do
        with_env(PATH: "#{formula_opt_bin("rust")}:#{ENV["PATH"]}") do
          system formula_opt_bin("rust")/"cargo", "fetch", "--locked"
        end
      end
    end
  end

  def install
    build_resources = %w[
      flit-core
      packaging
      pathspec
      poetry-core
      setuptools
      calver
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
      hatch-vcs
      wheel
    ]

    ENV.append_path "PYTHONPATH", formula_opt_prefix("maturin")/Language::Python.site_packages("python3.14")
    ENV.prepend_path "PATH", libexec/"bin"
    ENV["CARGO_NET_OFFLINE"] = "true"

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    resource("uv-build").stage do
      venv.pip_install Pathname.pwd/"crates/uv-build", build_isolation: false
    end
    legacy_venv = virtualenv_create(buildpath/"uv-build-legacy", "python3.14")
    resource("uv-build-legacy").stage do
      legacy_venv.pip_install Pathname.pwd/"crates/uv-build", build_isolation: false
    end
    legacy_resources = %w[pytrash textual-drivers]
    with_env(PYTHONPATH: "#{legacy_venv.site_packages}:#{ENV["PYTHONPATH"]}",
             PATH:       "#{buildpath}/uv-build-legacy/bin:#{ENV["PATH"]}") do
      legacy_resources.each { |name| venv.pip_install resource(name), build_isolation: false }
    end
    excluded_resources = build_resources + legacy_resources + %w[uv-build uv-build-legacy]
    venv.pip_install resources.reject { |r| excluded_resources.include?(r.name) }, build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rovr --version")
    system formula_opt_bin("python@3.14")/"python3.14",
           "-m", "pip", "--python", libexec/"bin/python", "check"

    ENV["ROVR_CONFIG_FOLDER"] = testpath/"config"
    ENV["XDG_CONFIG_HOME"] = testpath/"xdg-config"
    ENV["XDG_STATE_HOME"] = testpath/"xdg-state"
    ENV["XDG_CACHE_HOME"] = testpath/"xdg-cache"
    (testpath/"config/config.toml").write <<~TOML
      [interface.image_viewer]
      protocol = "Halfcell"
      [settings]
      drive_exclude = ["*"]
    TOML
    (testpath/"config/pins.json").write JSON.generate(
      default: [{ name: "Fixture", path: (testpath/"files").to_s }], pins: [],
    )
    (testpath/"smoke.py").write <<~PYTHON
      import asyncio
      import sys
      from pathlib import Path
      from compression import zstd
      from PIL import Image
      import rovr.monkey_patches._platform
      import rovr.monkey_patches._textual
      from rovr.app import Application

      assert sys.version_info[:2] == (3, 14)
      assert Path(Image.core.__file__).resolve().is_relative_to(Path("#{formula_opt_prefix("pillow")}").resolve())
      assert zstd.decompress(zstd.compress(b"Homebrew fixture")) == b"Homebrew fixture"

      files = Path("files")
      files.mkdir()
      (files / "note.txt").write_text("Homebrew fixture\\n")
      pixels = [(255, 0, 0), (0, 128, 255)]
      image = Image.new("RGB", (2, 1))
      image.putdata(pixels)
      for name, format in [("sample.png", "PNG"), ("sample.webp", "WEBP")]:
          image.save(files / name, format=format, lossless=True)
          with Image.open(files / name) as decoded:
              assert decoded.format == format
              assert decoded.size == (2, 1)
              assert list(decoded.convert("RGB").getdata()) == pixels

      async def smoke():
          target = (files / "sample.png").resolve()
          app = Application(startup_path=str(target))
          async with app.run_test(size=(120, 40)) as pilot:
              async with asyncio.timeout(30):
                  while not app.query(".image_preview"):
                      await pilot.pause(0.1)
                  assert {option.dir_entry.name for option in app.file_list.options} == {
                      "note.txt", "sample.png", "sample.webp"
                  }
                  assert Path(app.file_list.highlighted_option.dir_entry.path) == target
                  preview = app.query_one(".image_preview")
                  assert type(preview).__name__ == "HalfcellImage"
                  assert preview.image.size == (2, 1)
                  assert list(preview.image.convert("RGB").getdata()) == pixels
                  app.file_list.focus()
                  await pilot.press("v", "insert")
                  assert app.file_list.select_mode == "explicit"
                  assert len(app.file_list.selected) == 1
                  assert await app.file_list.get_selected_objects() == [str(target)]
                  await pilot.press("insert")
                  assert await app.file_list.get_selected_objects() == []

      if __name__ == "__main__":
          asyncio.run(smoke())
    PYTHON
    system libexec/"bin/python", testpath/"smoke.py"
  end
end
