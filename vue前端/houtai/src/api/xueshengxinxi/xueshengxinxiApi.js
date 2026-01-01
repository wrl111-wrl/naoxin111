import request from '@/utils/request';
// list
export const xueshengxinxiList = (params) => {
    return request({
        url: '/xueshengxinxi/page',
        method: 'post',
        data: params,
    })
};
export const xueshengxinxiDetail = (id) => {
    return request({
        url: '/xueshengxinxi/'+id,
        method: 'get',
    })
};
// add
export const xueshengxinxiSave = (params) => {
    return request({
        url: '/xueshengxinxi',
        method: 'post',
        data: params,
    })
};
// updt
export const xueshengxinxiEdit = (params) => {
return request({
        url: '/xueshengxinxi',
        method: 'put',
       data: params,
    })
};
//

// delete
export const xueshengxinxiDelete = (id) => {
    return request({
        url: '/xueshengxinxi/'+id,
        method: 'delete',
    })
};
// pldel
export const xueshengxinxiDeleteList = (xueshengxinxis) => {
    return request({
        url: '/xueshengxinxi/deleteList',
        data:{list:xueshengxinxis},
        method: 'post',
    })
};
// all
export const xueshengxinxiAllList = () => {
    return request({
        url: '/xueshengxinxi',
        method: 'get',
    })
};
export const xueshengxinxiUpdatePassword = (params) =>{ return request({ url: `/xueshengxinxi/updatePassword`, method: 'put',data: {...params,mima:params.password}, })};
export const xueshengxinxi_tj_xingbie = () => {return request({url: '/xueshengxinxi/xueshengxinxi_tj_xingbie',method: 'get',})};
export const xueshengxinxi_tj_banji = () => {return request({url: '/xueshengxinxi/xueshengxinxi_tj_banji',method: 'get',})};
