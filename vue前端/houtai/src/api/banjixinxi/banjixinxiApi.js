import request from '@/utils/request';
// list
export const banjixinxiList = (params) => {
    return request({
        url: '/banjixinxi/page',
        method: 'post',
        data: params,
    })
};
export const banjixinxiDetail = (id) => {
    return request({
        url: '/banjixinxi/'+id,
        method: 'get',
    })
};
// add
export const banjixinxiSave = (params) => {
    return request({
        url: '/banjixinxi',
        method: 'post',
        data: params,
    })
};
// updt
export const banjixinxiEdit = (params) => {
    return request({
        url: '/banjixinxi',
        method: 'put',
        data: params,
    })
};
// delete
export const banjixinxiDelete = (id) => {
    return request({
        url: '/banjixinxi/'+id,
        method: 'delete',
    })
};
// pldel
export const banjixinxiDeleteList = (banjixinxis) => {
    return request({
        url: '/banjixinxi/deleteList',
        data:{list:banjixinxis},
        method: 'post',
    })
};
// all
export const banjixinxiAllList = () => {
    return request({
        url: '/banjixinxi',
        method: 'get',
    })
};

