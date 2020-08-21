# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

DISTUTILS_OPTIONAL=1

inherit cmake distutils-r1

DESCRIPTION="Datasets, transforms and models to specific to computer vision"
HOMEPAGE="https://github.com/pytorch/vision"
SRC_URI="https://github.com/pytorch/vision/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda ffmpeg +python test"

REQUIRED_USE="ffmpeg? ( python )
	test? ( python )"

COMMON_DEPEND="
	python? (
		dev-python/av[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/tqdm[${PYTHON_USEDEP}]
		sci-libs/scipy[${PYTHON_USEDEP}]
	)
	sci-libs/pytorch[cuda?,python?,${PYTHON_USEDEP}]
	ffmpeg? ( media-video/ffmpeg )
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )"

DEPEND="${COMMON_DEPEND}
	dev-qt/qtcore:5
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/vision-${PV}"

PATCHES=(
	"${FILESDIR}/0001-Control-support-of-ffmpeg-0.6.0.patch"
)

pkg_setup() {
	if use cuda; then
			export TORCH_CUDA_ARCH_LIST="3.5;3.7;5.0;5.2;5.3;6.0;6.0+PTX;6.1;6.1+PTX;6.2;6.2+PTX;7.0;7.0+PTX;7.2;7.2+PTX;7.5;7.5+PTX"
	fi
}

python_test() {
	py.test -v -v || die
}

src_configure() {
	cmake_src_configure

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake_src_compile

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		MAKEOPTS="-j1" \
		distutils-r1_src_compile
	fi

}

src_install() {
	cmake_src_install

	if use python; then
		FORCE_CUDA=$(usex cuda 1 0) \
		CUDA_HOME=$(usex cuda ${CUDA_HOME} "") \
		ENABLE_FFMPEG=$(usex ffmpeg 1 0) \
		distutils-r1_src_install
	fi

	local multilib_failing_files=(
		libtorchvision.so
	)

	for file in ${multilib_failing_files[@]}; do
		mv -f "${ED}/usr/lib/${file}" "${ED}/usr/$(get_libdir)"
	done

}
